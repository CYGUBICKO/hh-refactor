#### Function produces bar graph: given data,  variable and the label of the variable
# df: Data frame
# 1. variable: variable to plot - wrapped in ""
# 2. wrap_labels: Number of characters to wrap in long text in labels. Value of 1 means no wrapping
# 3. xlabel: Text to display on the axis
# 4. show_percent_labels: Whether to show percentages on the bar graphs
# 5. shift_axis: Whether to rotate the axis

simplePlot <- function(df, variable, wrap_labels = 1, xlabel = "", bins=NULL, show_percent_labels = TRUE, shift_axis = FALSE, sort_x = TRUE, title = ""){
	df <- (df
		%>% rename(temp_var = !!variable)
	)
	if(wrap_labels == 1){
		if (sort_x){
			p0 <- ggplot(df, aes(x = fct_infreq(temp_var), group = 1))
		} else {
			p0 <- ggplot(df, aes(x = temp_var, group = 1))
		}
	} else {
		if (sort_x){
			p0 <- ggplot(df, aes(x = fct_infreq(str_wrap(temp_var, wrap_labels)), group = 1))
		} else {
			p0 <- ggplot(df, aes(x = str_wrap(temp_var, wrap_labels), group = 1))
		}
	}
	p0 <- (p0
		+ geom_bar(aes(y = ..prop..), stat = "count")
		+ scale_y_continuous(labels = percent)
	)
	if (class(df$temp_var)=="numeric"|class(df$temp_var)=="interger"){
		p0 <- (ggplot(df, aes(x = as.numeric(temp_var)))
			+ geom_histogram(bins=bins)
#			+ xlim(limits = range(df$temp_var, na.rm = TRUE))
		)
	}
	p0 <- p0 + labs(x = xlabel, y = "", title = title)
	if (show_percent_labels){
		p1 <- p0 +   geom_text(aes( label = scales::percent(..prop.., accuracy = 0.1)
			, y = ..prop..
		), stat= "count", vjust = -.1, hjust = 0)
	} else {
		p1 <- p0
	}
	if (shift_axis){
		p1 <- p0 + coord_flip()
		if (show_percent_labels){
			p1 <- p1 +   geom_text(aes(label = scales::percent(..prop.., accuracy = 0.1)
				, y = ..prop..
			), stat= "count", vjust = 0, hjust = -.1)
		}
	}

	return(p1)
}


#### Multiple response plot
# 1. var_patterns: starting string of multiple questions
# 2. question_labels: human readable labels appearing in the questionnaire. If missing it returns the names as in the data
# 3. distinct_quiz: Whether grouped questions are multiple response or distinct (grouped together but asking different things)
# 4. sum_over_N: Base for multiple response questions. True sums over total number of interviews, otherwise, sums over total number of selections
# 5. xlabel, show_percent_labels, shift_axis: as defined above

multiresFunc <- function(df, var_patterns, question_labels
	, distinct_quiz = FALSE, wrap_labels = 1
	, sum_over_N = TRUE, xlabel = "", show_percent_labels = TRUE
	, shift_axis = FALSE, title = "", NULL_label = "Unimproved"){
	if (length(var_patterns)>1){
		varnames <- grep(paste0("^", var_patterns, collapse = "|"), colnames(df), value = TRUE)
	} else {
		varnames <- grep(paste0("^", var_patterns), colnames(df), value = TRUE)
	}
	N <- NROW(df)
	df <- (df
		%>% select(!!varnames)
		%>% gather(temp_var_label, temp_var_values, !!varnames)
		%>% mutate(temp_var_values = as.factor(temp_var_values)
				, temp_var_values = fct_recode(temp_var_values
					, NULL = NULL_label
			)
		)
		%>% filter(!is.na(temp_var_values))
	)

	if(!missing(question_labels)){
		df <- (df 
			%>% mutate(temp_var_label = fct_recode(temp_var_label
				, !!!question_labels)
			)
		)
	}

	if (!distinct_quiz){
		if(wrap_labels == 1){
			p0 <- ggplot(df, aes(x = fct_infreq(temp_var_label)))
		} else {
			p0 <- ggplot(df, aes(x = fct_infreq(str_wrap(temp_var_label, wrap_labels))))
		}
	} else {
		if(wrap_labels == 1){
			p0 <- ggplot(df, aes(x = fct_reorder(temp_var_label, as.numeric(temp_var_values), .fun = sum), fill = temp_var_values))
		} else {
			p0 <- ggplot(df, aes(x = fct_reorder(str_wrap(temp_var_label, wrap_labels), as.numeric(temp_var_values), .fun = sum), fill = temp_var_values))
		}
		
	}

 	p1 <- (p0
 		+ labs(x = xlabel, y = "", title = title)
 	)
	
	if(sum_over_N){
		p1 <- (p1
 			+ geom_bar(aes(y = (..count..)/N))
 			+ scale_y_continuous(labels = percent)
		)
		if (show_percent_labels){
			if (!shift_axis){
				p2 <- p1 +   geom_text(aes( label = scales::percent(..count../N)
					, y = ..count../N
				), stat= "count", vjust = -.1, hjust = 0)
			} else {
				p2 <- p1 +   geom_text(aes( label = scales::percent(..count../N)
					, y = ..count../N
				), stat = "count", vjust = 0, hjust = -.1)
			}
		} else {
			p2 <- p1
		}
	} else {
		p1 <- (p1
 			+ geom_bar(aes(y = (..count..)/sum(..count..)))
 			+ scale_y_continuous(labels = percent)
		)	
		if (show_percent_labels){
			if (!shift_axis){
				p2 <- p1 +   geom_text(aes( label = scales::percent(..count../sum(..count..))
					, y = ..count../sum(..count..)
				), stat= "count", vjust = -.1, hjust = 0)
			} else {
				p2 <- p1 +   geom_text(aes( label = scales::percent(..count../sum(..count..))
					, y = ..count../sum(..count..)
				), stat = "count", vjust = 0, hjust = -.1)
			}
		} else {
			p2 <- p1
		}
	}
	
	if (shift_axis){
		p2 <- p2 + coord_flip()
	}
	
	if (distinct_quiz){
		p2 <- (p2 
			+ scale_fill_viridis_d(option = "inferno")
			+ labs(fill = "Responses")
			+ theme(legend.position = "right")
		)
		
	}
	return(p2)
}

saveEnvironment()
