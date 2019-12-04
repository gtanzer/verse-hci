make clean \
&& make; \
(mkdir output; mkdir output/synthesis; mkdir output/synthesis/grammar); \
./main.native \
&& (cd output && dotnet build && dotnet run)
