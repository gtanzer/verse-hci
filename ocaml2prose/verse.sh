if [ "$#" -ne 1 ]; then
    FILE="corpus.txt"
    echo "using default corpus location," $FILE
else FILE=$1
fi
make clean \
&& make; \
(mkdir output; mkdir output/synthesis; mkdir output/synthesis/grammar); \
./main.native $FILE \
&& (cd output && dotnet build && dotnet run)
