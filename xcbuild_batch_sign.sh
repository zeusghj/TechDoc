#此脚本可以将ios批量打包成channels中定义的渠道包，并且进行了签名（in house），前提是
#已经在info.plist文件中定义了Channel这个key，渠道的值就
#可以根据这个Channel获取得到。
#获取Channel的值：
#NSString* channel = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Channel"];


xcodebuild -project ./Semm.xcodeproj -scheme Semm -configuration Release archive -archivePath ./archives/archive

channels=("guo" "hong" "jun")

for i in ${channels[@]}
do
    /usr/libexec/PlistBuddy -c "Set :Channel ""$i" ./archives/archive.xcarchive/Products/Applications/*.app/info.plist
    rm -Rf ./archives/"yykb_"$i.ipa
    xcodebuild -exportArchive -archivePath ./archives/archive.xcarchive -exportPath ./archives/"yykb_"$i.ipa -exportWithOriginalSigningIdentity

    unzip ./archives/"yykb_"$i.ipa

    rm -rf ./Payload/Semm.app/_CodeSignature

    cp ./yyqvdapns.mobileprovision ./Payload/Semm.app/embedded.mobileprovision

    codesign -f -s "iPhone Distribution: Beijing Ding Xin Chuang Heng Technology Co., Ltd." --entitlements="./entitlements.plist" ./Payload/Semm.app

    zip -r ./archives/"new_yykb_"$i.ipa ./Payload

    rm -rf ./Payload

done
rm -Rf ./archives/archive.xcarchive


#entitlements.plist 示例在目录中有，
#代码比较简单，如果有不懂得，打包的时候根据错误提示也可以很快的掌握
