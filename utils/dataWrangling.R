# make sure to use this library, not rjson, which also as function called fromJSON
library("jsonlite") 

# function for loading one subject's data
to_tibble_one_subject_results <- function(subject, path) {
  
  # Filename format: subject_results.txt
  filename <- paste(path,subject, "_results.txt", sep="")  
  
  # Each section of the test is a JSON root element [][][] etc
  # Load the results of each section into a data frame    
  results_chr <- readLines(filename)
  results_df <- lapply(results_chr[2:length(results_chr)], function(elt) {
    elt <- fromJSON(elt)
  })
  # then merge all the data frames
  results_df <- do.call("rbind", results_df) 
  
  results_tib <- as_tibble(results_df) %>%
    # Only keep the columns we care about
    select(c(carrier_syllable, eval_params, selected_tone)) %>%
    # For now, filter out the repeat rounds
    filter(selected_tone != -2) %>%
    # Also filter the "not a tone" results
    # filter(selected_tone != -1) %>%
    # Convert tone names to "TX"
    mutate(selected_tone = paste("T", selected_tone, sep="")) %>%
    # Replace -1 other
    mutate(selected_tone = replace(selected_tone, selected_tone=="T-1", "TN")) %>%
    # (For multinomial logit) replace 3 with other
    #mutate(selected_tone = replace(selected_tone, selected_tone=="T3", "TOther")) %>%
    # Put start and end parameters into different columns
    mutate(eval_start=(as.numeric(substr(eval_params, 1, 1))-1)*2,
           eval_end=(as.numeric(substr(eval_params, 3, 3))-1)*2, subject=subject) %>%
    # Start and end points are already in terms of semitone differences
    # We want to center them
    mutate(start.freq = (max(eval_start)/2)-eval_start,
           end.freq = (max(eval_end)/2)-eval_end,
           # make another column for the frequency shift (intrasyllable interval)
           freq.shift = end.freq-start.freq)
  
  # Convert selected_tone to factor   
  results_tib$selected_tone <- as.factor(results_tib$selected_tone)
  return(results_tib)
}

# Function to load everyone's data
get_results <- function(subjects, my_path) {
  do.call("rbind",lapply(subjects, to_tibble_one_subject_results,path=my_path))
}

# Returns tibble with binary-coded column for whether my_tone is selected
data_for_selected_tone <- function(data, my_tone) {
  mutate(data, is.tone = ifelse(selected_tone == my_tone, 1, 0))
}