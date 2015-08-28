#! /bin/bash
FILEtest="t0.out";
FILEdiff="t1.out";
FILE1Array="";
FILE2Array="";
i=0;
f=0;
o=0;
b=true;


for file in "testScan"/* 
   do
     if `echo ${file} | grep "\.simpl" 1>/dev/null 2>&1`; then
	         testF[$f]=${file}
	         f=$[$f+1]
     fi
	 
     if `echo ${file} | grep "\.test" 1>/dev/null 2>&1`; then
         testO[$o]=${file}
         o=$[$o+1]
     fi
 
     i=$[$i+1]
 done;
 i=0;

function error {
	echo "<td><a href= '$2' ><font color=red> $1 </font></a></td>" >> $FILE
}

function right {
	echo "<td><a href= '$2'><font color=green> $1 </font></a></td>" >> $FILE
}

function html {
	echo "">$1
	echo "<html>" >> $1
	echo "OUTPUT FROM THE CREATOR<br><br>">> $1
	cat $2 >> $1
	echo "<br><br>OUTPUT FROM THE PEASANT<br><br>">>$1
	cat $3 >> $1
	echo "</html>" >> $1
}

if [ ! -d "testCases/" ]; then
    # Control will enter here if $DIRECTORY exists.
	mkdir testCases
fi

FILE="testCases/index.html"

echo "" > $FILE
echo "<html>" >> $FILE
echo "<head>" >> $FILE

echo "Please let me know if you have any disagreements with the testcases at 18729479@sun.ac.za" >>$FILE

echo "</head>" >> $FILE


echo "<table border='1' style='width:800px'>" >> $FILE

while $b; do
	FILEhtml="testCases/test$i.html"
	if [ -z "${testF[$i]}" ] ; then
          b=false;
          break;
    fi
	 
	echo "<td> $i </td>" >> $FILE
    ./src/$1 ${testF[$i]} &> $FILEtest
	diff ${testO[$i]} $FILEtest &> $FILEdiff
	echo "<td>${testF[$i]}</td>" >> $FILE
	html $FILEhtml ${testO[$i]} $FILEtest
	if [ -s $FILEdiff ]; then
           error "${testF[$i]}" "test$i.html"
	else
       right "${testF[$i]}" "test$i.html"
	fi
	echo "<td>${testO[$i]}</td>" >> $FILE
	rm $FILEtest;
	rm $FILEdiff;	
	FILEtest="t0.out";
	FILEdiff="t1.out";


    i=$[$i+1]
	echo "</tr>" >> $FILE
done;


echo "</table>" >> $FILE


echo "</html>" >> $FILE
echo "Choose your browser FIREFOX(0) and GOOGLE-CHROME(1)"
read a
if [ a==0 ]
	firefox $FILE
elif [ a==1 ] 
	google-chrome $FILE
fi
