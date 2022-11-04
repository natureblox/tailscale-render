mkdir up	
mv *.txt up
tar cvzf k1-`date -I`.tgz ./up/
curl --upload-file k1-`date -I`.tgz https://share.schollz.com/
