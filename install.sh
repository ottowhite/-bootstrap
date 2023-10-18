GREEN='\033[1;32m'
NC='\033[0m' # No Color

confirm_and_run_commands() {
        confirmation_message="$1"
        shift

        echo "$confirmation_message" "(y/n) "
        read -r answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
                for cmd in "$@"
                do
                        echo
                        printf "${GREEN}Running command: \"%s\"${NC}\n" "$cmd"

                        # Print a full line of dashes
                        printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -

                        eval "$cmd"
                        echo
                done
        fi
}

confirm_and_run_commands \
	"Install basic packages?" \
	"sudo apt update -y && sudo apt install -y \
		neovim \
		make \
		curl \
		git \
		fzf \
		tree \
		python3"

confirm_and_run_commands \
	"Install ZSH and Oh My Zsh?" \
	"sudo apt update -y && sudo apt install -y zsh" \
	"sh -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \

confirm_and_run_commands \
  "Install ZSH plugins?" \
	"git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" \
	"git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" \
	"echo [INSTRUCTION] Construct .zshrc" \
	"echo [INSTRUCTION] Source .zshrc"

confirm_and_run_commands \
	"Pull configuration files?" \
	"git clone http://github.com/ottowhite/simple-config-manager.git" \
	"cd simple-config-manager" \
	"./synchronize.sh"

confirm_and_run_commands \
  "Install Docker?" \
  "echo [INFO] Find manual instructions at: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository" \
	"for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done" \
  "echo [INFO] Allowing APT to use repo over HTTPS "\
	"sudo apt-get update -y && sudo apt-get install -y ca-certificates curl gnupg" \
  "echo [INFO] Adding docker official gpg key" \
	"sudo install -m 0755 -d /etc/apt/keyrings" \
 	"curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg" \
 	"sudo chmod a+r /etc/apt/keyrings/docker.gpg" \
  "echo [INFO] Setting up the repository" \
	"echo \
  	'deb [arch='$(dpkg --print-architecture)' signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  	'$(. /etc/os-release && echo "$VERSION_CODENAME")' stable' | \
  	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null" \
  "echo [INFO] Installing using APT" \
	"sudo apt-get update -y && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin" \
  "echo [INFO] Adding user to the docker usergroup so docker can be used without Sudo" \
	"sudo usermod -aG docker $USER" \
	"echo [INSTRUCTION] Configure wsl.conf to use systemd if in WSL" \
	"echo [INSTRUCTION] Start the docker daemon"

# TODO: Add SSH key creation
