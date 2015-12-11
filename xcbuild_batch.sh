#此脚本可以将ios批量打包成channels中定义的渠道包，前提是
#已经在info.plist文件中定义了Channel这个key，渠道的值就
#可以根据这个Channel获取得到。
#获取Channel的值：
#NSString* channel = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Channel"];


xcodebuild -project ./Semm.xcodeproj -scheme Semm -configuration Release archive -archivePath ./archives/archive

channels=("guo" "hong" "jun")

for i in ${channels[@]}
do
    /usr/libexec/PlistBuddy -c "Set :Channel ""$i" ./archives/archive.xcarchive/Products/Applications/*.app/info.plist
    rm -Rf ./archives/$i.ipa
    xcodebuild -exportArchive -archivePath ./archives/archive.xcarchive -exportPath ./archives/$i.ipa -exportWithOriginalSigningIdentity
done
rm -Rf ./archives/archive.xcarchive



#代码比较简单，如果有不懂得，打包的时候根据错误提示也可以很快的掌握
