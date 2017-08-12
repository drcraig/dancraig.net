path=`dirname $0`
cd $path
if [ ! -d node_modules ];then
    pm install
fi
grunt build
