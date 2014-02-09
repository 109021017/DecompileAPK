apktoolpath='./apktool'
dex2jarpath='./dex2jar'
jadpath='./jad'

if [ $# -lt 1 ]; then
	echo "you should input an apk file to decode"
	exit 0
fi

apkfile=$1
test -f $apkfile || (echo "you should input an apk file to decode" && exit 0)
apkfilebasename=$(basename $apkfile)

if [ "${apkfilebasename:(-4)}" != ".apk" ];then
	echo "you should input an apk file to decode"
	exit 0
fi
apkfilebasename=${apkfilebasename/%.apk/}
outdir="./$apkfilebasename"

"$apktoolpath/apktool" d -s "$apkfile" "$outdir"
 
bash "$dex2jarpath/d2j-dex2jar.sh" "$outdir/classes.dex"
mv "./classes-dex2jar.jar" "$outdir"
unzip "$outdir/classes-dex2jar.jar" -d "$outdir/classes"

"$jadpath/jad" -o -r -sjava -d"$outdir/src" "$outdir/classes/**/*.class"

rm -rf "$outdir/classes"
rm "$outdir/classes.dex"
rm "$outdir/classes-dex2jar.jar"
