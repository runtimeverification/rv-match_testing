# To activate ssh key: git remote set-url origin git@github.com:TimJSwan89/rv-match_testing.wiki.git
git clone https://github.com/TimJSwan89/rv-match_testing.wiki.git
cd rv-match_testing.wiki
echo "Start of auto generated wiki page.  " > Auto-Generated-Table.md
echo "A script generated this wiki page.  " >> Auto-Generated-Table.md
echo "More is here. Are new lines working?  " >> Auto-Generated-Table.md
echo "  " >> Auto-Generated-Table.md
echo "| Sample | Table |  " >> Auto-Generated-Table.md
echo "| --- | --- |  " >> Auto-Generated-Table.md
echo "| Dog | Hairy |  " >> Auto-Generated-Table.md
echo "| Cat | Angry |  " >> Auto-Generated-Table.md
git add Auto-Generated-Table.md
git commit -am "Auto generated commit."
git push
