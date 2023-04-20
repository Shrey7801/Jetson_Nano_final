#  This script will clean all the data in "Pictures" and "Videos" folder.

cd

echo "------------------WARNING------------------"
echo "Do you want to delete all the data in Picture and Videos? [Y or N]"
read choice

if [ $choice = "Y" ] || [ $choice = "y" ];
then
    sudo rm -rf Videos/*
    sudo rm -rf Pictures/*
    echo "All data deleted from Pictures and Videos Folder."
else
    echo "Delete cancelled"
fi
