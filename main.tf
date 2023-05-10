module "network" {
    source = "./modules/network"
    jenkins_instance = module.jenkins.jenkins_instance
}

module "jenkins" {
    source = "./modules/jenkins"
    project_name = module.network.project_name
    public_subnet = module.network.public_subnet_id
    jenkins_sg = module.network.jenkins_sg

  
}