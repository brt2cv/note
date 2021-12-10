#!/bin/bash

# 该脚本仅用于hugo项目的创建
str_usage="Usage: hugo_exec.sh [server]"
test ${1}_ == "-h_" && echo $str_usage && exit
[ $1 ] && [ ${1}_ != "server_" ] && echo "未知的参数项【${1}】" && exit

themes="eureka"  # 或者: ananke, or
hugo_dir="site"
git_repo=${hugo_dir}/publish

if [ ! -d $hugo_dir ]; then
    echo "新建hugo项目"
    hugo new site $hugo_dir  # -f yaml

    if [ $themes == "ananke" ]; then
        # 下载主题
        # git clone --depth=1 https://gitee.com/brt2/ace-documentation.git ${hugo_dir}/themes/curr
        git clone --depth=1 -b v2.5.6 https://github.com/budparr/gohugo-theme-ananke.git ${hugo_dir}/themes/curr

        # > [配置文件](https://gohugo.io/getting-started/configuration)
        # > [Sample](https://blog.csdn.net/lastsweetop/article/details/78141282)
        # mv -f hugo_config.yaml ${hugo_dir}/config.yaml
        # test -d ${git_repo} || git clone git@gitee.com:brt2/blog.git ${git_repo}

    elif [ $themes == "eureka" ]; then
        # 不同主题操作可能不同
        git clone --depth=1 -b v0.8.4 https://github.com/wangchucheng/hugo-eureka.git ${hugo_dir}/themes/eureka
        # git clone --depth=1 -b v0.8.4 https://gitee.com/wangchucheng/hugo-eureka.git ${hugo_dir}/themes/eureka
        echo "已经下载主题【eureka】，请前往【${hugo_dir}】目录手动修改配置，详情参考：https://www.wangchucheng.com/en/docs/hugo-eureka/getting-started/"
        # 启动程序: cd ${hugo_dir} && mv themes/eureka/exampleSite/* . && hugo server
        exit
    fi
fi

hugo $1 --config="./hugo_config.yaml"

# git_repo推送
# read -p 'Try to git-push blog_repo? ([Y]/n) ' ok
# if [ ${ok}_ != "n_" ]; then
#     cd ${git_repo}
#     git add . && git commit -m "$(date)"
#     git push origin master
# fi
# echo "Blog 数据已更新，请前往【https://gitee.com/brt2/blog/pages】更新 Gitee Pages 服务"
