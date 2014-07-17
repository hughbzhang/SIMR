#Helper function for cutting up the data in the GBM Data Set
cut -f $1 -d ' ' DATA/ALLDATA.txt >try.txt && head try.txt
