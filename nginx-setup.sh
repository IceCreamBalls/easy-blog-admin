project_version='easy-blog-web-1.0.0';
project_name='easy-blog-web-1.0.0';
docker_project_name='cheeringandann/easy-blog-web';

d=`data "+%Y-%m-%d %H:%M:%S"`
echo "------------------构建时间：${d}----------------------"
echo "------------------拉取项目 ---------------------------"
# git pull https://github.com/IceCreamBalls/easyBlogweb.git

echo "------------------删除旧镜像--------------------------"
docker  stop ${project_name};
docker rm ${project_name};
docker rmi ${project_name};
echo "------------------创建镜像---------------------------"
docker build -f ./dockerfile/easyblog-dockerfile -t ${project_name} .;
echo "-------------------查看镜像--------------------------"
docker run -d --restart=always --name ${project_name} -p 8089:80 ${project_name};
c=$?
if [$c -ne 0]; then
    echo '启动失败';
    docker rmi ${project_name}
    exit 1;
fi
echo "-------------------输出日志--------------------------"
docker logs ${project_name}
finish_time=`date "+%Y-%m-%d %H:%M:%S"`;
echo "-------------------构建完毕${finish_time}------------"
echo "-------------------登录 docker ----------------------"
docker login || ! echo '登录失败' || exit;
echo "---------------------创建${docker_project_name}:${project_version}分支------"
docker tag easy-blog-web-1.0.0 ${docker_project_name}:${project_version};
echo "---------------------创建完毕-------------------------"
echo "---------------------上传至docker hub 仓库-------------"
docker push ${docker_project_name}:${project_version} || ! echo '上传失败' || exit;
echo "---------------------上传完成--------------------------"
