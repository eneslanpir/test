#Ubuntu Server ön kurulum komutları oku&kur sh dosyası

#Dikkat! Aşağıdaki yapılandırma komutlarından kullanmak istemediklerinizi listeden çıkarın.
#Dikkat! Parantez içerisinde ki istenen bilgileri doldurup parantezi kaldırın.

#Aşağıdaki komut öncelikle root veya sudo user ile çalıştırın.
# sudo chmod x+ ubuntulinuxkonfig.sh

#Her makinanını hostname'i farklı olacağı için aşağıdaki komut ile sunucusuna makine adı verin.
# sudo hostnamectl set-hostname (makina adınız)

#SSH bağlatınıza root kullanıcısna izin vereceksiniz veya root session geçişi yapacaksanız aşağıda ki 
#komut ile root kullanıcısı şifresinizi ayarların. Bknz: 39. satır
# sudo passwd root

#Bu noktadan sonra sh dosyasını kapatın ve aşağıdaki komut ile sh dosyasının kayıtlı olduğu dizinde çalıştırın.
# sudo ./ltubuntulinuxkonfig.sh

#Ubuntu güncelleme ve yükseltme
sudo apt-get -y update
sudo apt-get -y upgrade
#Sunucu time zone ayarlama
sudo timedatectl set-timezone Europe/Istanbul
#Apparmor kaldırma
sudo apt purge apparmor -y
#Uunbtu firewall'u devre dışı bırakma
sudo ufw disable
#Net tools kurulumu
sudo apt install net-tools -y
#deb file kurulum yöetnicisi kurulumu
sudo apt-get install gdebi -y
#ping paket kurulumu
sudo apt-get install -y iputils-ping
#LVM kullanılmayan disk bölümü serbest bırakma
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
#LVM disk boyutunu genişletme
sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
#SSH root userına izin verme
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#SSH servisini yeniden başlatma
sudo systemctl restart restart ssh
#Sudo yetki genişletme şifresini devre dışı bırak
sudo echo "lt ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/local
#Admin yetkilerinizi genişletin
sudo echo "lt ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers.d/local
#Open Vmtools'u kurun
sudo apt-get install open-vm-tools -y
#Cockpit, linux sunucu yönetimi web arayüzü servisi yükle
sudo apt-get install cockpit -y
sudo systemctl enable --now cockpit.socket
sudo usermod -aG sudo USER
#Docker GPG keylerin eklenmesi
sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
#Docker repolarının eklenmesi
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
#En son Docker versiyonunun yüklenmesi
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
#Docker Compose plug-ing olarak yükleme
sudo apt-get install docker-compose-plugin -y
#Docker Compose tek başına çalışır halde yükleme
curl -SL https://github.com/docker/compose/releases/download/v2.24.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo apt-get update
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
#Sunucuyu yeniden başlatma
sudo reboot



