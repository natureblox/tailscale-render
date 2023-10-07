echo "export LANG=zh_CN.UTF-8"  >> ~/.bashrc
echo "alias sbw='s -b w3m' "  >> ~/.bashrc
echo "curl cn.getnews.tech"   >> ~/.bashrc
echo "mdp -d sample.md "   >> ~/.bashrc
#echo "curl hkkr.in"   >> ~/.bashrc
echo "curl neuters.de"   >> ~/.bashrc

echo "https://www.medium.com/feed/@elife" >> /root/.newsboat/urls
echo $1 >> /root/.newsboat/urls
