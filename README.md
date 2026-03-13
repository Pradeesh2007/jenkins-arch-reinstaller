# Jenkins Arch Reinstaller

A professional **Bash automation script** that completely removes and reinstalls **Jenkins** on **Arch Linux / BlackArch Linux**.

This tool is useful for developers and DevOps engineers who want to **reset Jenkins to a clean state quickly** without manually removing packages, users, and data directories.

The script performs a **full cleanup and fresh installation**, then automatically retrieves the **initial Jenkins admin password**.

---

## Features

* Complete Jenkins removal
* Deletes Jenkins data directories
* Removes Jenkins system user and group
* Fresh Jenkins installation using `pacman`
* Automatic Jenkins service restart
* Internet connectivity check before installation
* Colored terminal output for better readability
* Safe exit handling with `Ctrl + C`
* Automatically retrieves the **initial admin password**

---

## Supported Systems

* Arch Linux
* BlackArch Linux
* Other Arch flavours

---

## Installation

Update first:

```bash
sudo pacman -Syu
```

Clone the repository:

```bash
git clone https://github.com/Pradeesh2007/jenkins-arch-reinstaller.git
```

Enter the project directory:

```bash
cd jenkins-arch-reinstaller
```

---

## Usage

Make the script executable:

```bash
chmod +x reinstall-jenkins.sh
```

Run the script:

```bash
./reinstall-jenkins.sh
```

The script will automatically:

1. Check internet connectivity
2. Stop Jenkins service
3. Remove Jenkins packages
4. Delete Jenkins data directories
5. Remove Jenkins system user
6. Install Jenkins again
7. Start Jenkins service
8. Display the **initial admin password**

---

## Access Jenkins

After installation Jenkins will be available at:

```
http://127.0.0.1:8090
```

The script will automatically display the **initial admin password** in the terminal.

---

## Example Output

```
[+] Internet connection detected
[+] Jenkins removed successfully
[+] Jenkins installed
[+] Jenkins started successfully
[+] Initial Admin Password: **************
```

---

## Requirements

* Arch Linux / BlackArch Linux
* sudo privileges
* Internet connection

---

## Contributing

Contributions, improvements, and bug fixes are welcome.

If you have ideas to improve this script, feel free to open an **Issue** or **Pull Request**.

---

## Author

Pradeesh Kumar

GitHub: https://github.com/Pradeesh2007/jenkins-arch-reinstaller.git
---


