Multi-Tier Web Application Deployment (Highly scalable)
Project link - https://www.youtube.com/watch?v=FZPTL_kNvXc&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze&index=9
Deployed a html page deployed in private ec2 instance inside private subnet &amp; accessing it...

Steps after creating infrastructure
1. login into bastion instance there will be key pair file using that
2. login to any private instance & use nano index.html
3. create a index.html file in both private instance one by one and then
4. In both private instacne start the python server using this command "python3 -m http.server 8000"  #8000 is the port on which server is running
5. then wait for 3-4 mins to get instances healthy in target group
6. then search for lb dns name in browser


Challenges
1. ec2 instances are launched by asg toh mujhe woh instances ke private ips chahiye the taki mai unhe interpolation me use kar saku
2. data source block ka use kiya, private ip mil gya
3. local m/c -> ssh bastion host -> ssh any private instance -> running server on 8000 port
4. bahut try kiya but solution nahi mila ki pura automate kaise karu
