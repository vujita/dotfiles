#!/bin/zsh

if [ -z $CODESPACES ]; then
	echo "Is not in CODESPACES"
	chmod +x post-install.sh
	./post-install.sh
else
	echo "Is in CODESPACES"
  chmod +x codespaces-setup.sh 
  echo "Run codespaces-setup.sh later"
  # ./codespaces-setup.sh
  # echo "Finished setup"
fi
