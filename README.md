# terraform-project
Deployed a html page deployed in private subnet &amp; accessing it...


Challenges
1. ec2 instances are launched by asg toh mujhe woh instances ke private ips chahiye the taki mai unhe interpolation me use kar saku
2. data source block ka use kiya, private ip mil gya
3. local m/c -> ssh bastion host -> ssh any private instance -> running server on 8000 port
4. but pura automate nahi ho paya jitna code commented hai na 1st line chod ke sab mujhe manually karna padega koi bhi ek instance me login kar ke
5. bahut try kiya but solution nahi mila ki pura automate kaise karu
