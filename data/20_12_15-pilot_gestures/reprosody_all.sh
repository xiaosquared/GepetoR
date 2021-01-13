# Format:
# ./reprosody_all.sh {path of all .txt files with pitch info} {target .wav} {output location}

# For example (can copy paste)
# ./reprosody_all.sh ../data/prosogram-results/syllab1/for_voks ../data/prosogram-results/syllab1/wav/flute_h.wav ../data/prosogram-results/syllab1/reprosody_output

#./reprosody_all.sh {base path}
# ./reprosody_all.sh ../data/prosogram-results/syllab1

LOCATION=$1

for fullfile in ${LOCATION}/for_voks/*.txt; do
    echo "Based on pitch curve defined by: " $fullfile

    # Get the core filename
    filename_extras="${fullfile##*/}"

    # Get the names of the original and the output audio files
    wavname="${filename_extras%-*}"
    outname="${filename_extras%.*}"
    echo "Transforming:  ${LOCATION}/audio/${wavname}.wav"
    echo "Output ${LOCATION}/reprosody_output/${outname}.wav"

    ./reprosody ${fullfile} "${LOCATION}/audio/${wavname}.wav" "${LOCATION}/reprosody_output/${outname}.wav"
    echo "Done \n"
    done
