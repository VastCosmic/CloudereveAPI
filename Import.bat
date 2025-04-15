@echo off
:: 设置控制台为UTF-8编码
chcp 65001 >nul
:: 设置控制台字体为支持中文的字体（可选）
reg add "HKCU\Console" /v "FaceName" /t REG_SZ /d "Lucida Console" /f >nul 2>&1

setlocal enabledelayedexpansion

:: =============== 全局配置 ===============
set "api_domain=xx.xx.com"
set "cookie_file=%temp%\api_cookies.txt"

:: =============== 用户登录配置 ===============
set "login_endpoint=/api/v3/user/session"
set "username="
set "password="
set "captcha_code="

:: =============== 任务导入配置 ===============
set "import_endpoint=/api/v3/admin/task/import"
set "uid=1"
set "policy_id=1"
set "src_path=/"
set "dst_path=/"
set "recursive=true"
:: =============== 配置结束 ===============

:: 构建完整URL
set "login_url=http://%api_domain%%login_endpoint%"
set "import_url=http://%api_domain%%import_endpoint%"

:: 显示配置信息
echo [配置信息]
echo.
echo API域名: %api_domain%
echo 登录URL: %login_url%
echo 用户名: %username%
echo 导入URL: %import_url%
echo 源路径: %src_path%
echo 目标路径: %dst_path%
echo.
echo.

:: 第一次请求 - 登录并保存cookies
echo [1/2] 正在登录...
echo.
curl --location "%login_url%" ^
--header "Content-Type: application/json" ^
--data-raw "{\"userName\": \"%username%\", \"Password\": \"%password%\", \"captchaCode\": \"%captcha_code%\"}" ^
--cookie-jar "%cookie_file%" ^
--silent --show-error

:: 检查是否成功获取cookies
if not exist "%cookie_file%" (
    echo [!] 错误: 登录失败，未能获取cookies
    exit /b 1
)
echo.
echo.

:: 第二次请求 - 使用cookies执行导入
echo [2/2] 正在导入任务...
echo.
curl --location "%import_url%" ^
--header "Content-Type: application/json" ^
--data "{\"uid\": %uid%, \"policy_id\": %policy_id%, \"src\": \"%src_path:\=\\\\%\", \"dst\": \"%dst_path%\", \"recursive\": %recursive%}" ^
--cookie "%cookie_file%" ^
--silent --show-error
echo.
echo.

:: 清理临时文件
del "%cookie_file%" >nul 2>&1

echo [完成] 操作执行完毕, 已启动 Cloudreve 导入 Task......
pause
