

#Set git email
git config --global user.email "julzzr@gmail.com"
#set git username
git config --global user.name "jigliPook"


cd /Users/yuliaryv/Documents/git            
git clone https://github.com/BenAssa123/ProtoFi.git


cd ProtoFi
touch new_test.txt

#Use the git status command to see the changes. Your new file should appear as "untracked".
git status

#Add the new file to the staging area.
#Use the git add command to add the new file. Replace filename with the name of your file.
git add filename

#If you want to add all new and changed files at once, you can use:
git add .
# ^ That's what I did

#Commit the changes.
#Use the git commit command to commit the added files to your local repository. Include a meaningful commit message.
git commit -m "Add new file"


# Optional pull Latest Changes
# pull the latest changes from the remote repository. to avoid conflicts.
#Replace "main" with whatever branch you're working on
git pull origin main

#Push the changes to the remote repository.
#Use the git push command to push your local commits to the remote repository. If you are using the default branch (often named main or master), you would use:
git push origin main

# I created a token for this rep (use it for authentication):


# a more permanent solution to avoid authentication:
git config --global credential.helper osxkeychain
