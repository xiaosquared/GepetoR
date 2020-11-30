hertz_to_semitones <- function(hertz_value, hertz_reference_value) {
  return(12 * log(hertz_value/hertz_reference_value) / log(2))
}

semitones_to_hertz <- function(st, ref) {
  return(2^(st/12) * ref)
}