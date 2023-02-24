read -p 'REPOSITORY: ' repository
echo git clone git@github.com:$GITHUB_ACCOUNT/$repository.git
git clone git@github.com:$GITHUB_ACCOUNT/$repository.git
