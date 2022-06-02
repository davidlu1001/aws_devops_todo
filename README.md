# AWS DevOps - Todo Sample Application

This repository provides a sample application based upon the [Todo-backend project](https://www.todobackend.com).

# How to run

- Build and run tests
```
make test
```

- Run the application locally
```
make release
```

- Login / Logout AWS ECR repository
```
make login
make logout
```

- Push the application image to the AWS ECR repository
```
make publish
```

- Clean up the application image
```
make clean
```

## Example - Complete Make Workflow
```
> git commit -a -m "Add publish target in Makefile"


> make login
aws ecr get-login-password --region "ap-southeast-2" | docker login --username AWS --password-stdin "XXXXXXXXXXX".dkr.ecr."ap-southeast-2".amazonaws.com
Enter MFA code for arn:aws:iam::XXXXXXXXXXX:mfa/david.lu:
Login Succeeded


> make test && make release
docker-compose build --pull release
Building release
[+] Building 3.6s (24/24) FINISHED
...
Creating aws_devops_todo_app_1 ... done
App running at http://localhost:4862


> make publish
docker-compose push release app
Pushing release (XXXXXXXXXXX.dkr.ecr.ap-southeast-2.amazonaws.com/aws-learn-devops/todobackend:latest)...
...
latest: digest: sha256:7d485fe9b7175f3619afa2cdf9170080fc4f47cad2145940fe54c14a1d57ff81 size: 2405
Pushing app (XXXXXXXXXXX.dkr.ecr.ap-southeast-2.amazonaws.com/aws-learn-devops/todobackend:0b3c16a)...
...
0b3c16a: digest: sha256:7d485fe9b7175f3619afa2cdf9170080fc4f47cad2145940fe54c14a1d57ff81 size: 2405


> make clean
docker-compose down -v
Stopping aws_devops_todo_app_1 ... done
...
Removing network aws_devops_todo_default
Removing volume aws_devops_todo_public
docker images -q -f dangling=true -f label=application=todobackend | xargs -I ARGS docker rmi -f --no-prune ARGS


> make logout
docker logout https://XXXXXXXXXXX.dkr.ecr.ap-southeast-2.amazonaws.com
Removing login credentials for XXXXXXXXXXX.dkr.ecr.ap-southeast-2.amazonaws.com
```

# AWS CodeBuild

For the AWS CodeBuild project, the [buildspec.yml](https://github.com/davidlu1001/aws_devops_todo/blob/final/buildspec.yml) file will be used by default.