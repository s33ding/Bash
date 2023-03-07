
echo "Please enter the name of the repository you want to clone."
read -p '😺REPOSITORY: ' repository
echo Cloning repository: $repository
echo git clone git@github.com:$GITHUB_ACCOUNT/$repository.git
git clone git@github.com:$GITHUB_ACCOUNT/$repository.git
echo Successfully cloned $repository! Happy exploring!
