# -----------------------------------------------------------------
# 脆弱な Dockerfile サンプル
# -----------------------------------------------------------------

# [Trivy]
# 1. 古いベースイメージを使用 (Debian 11 Bullseye)
# [Hadolint]
# 1. :latestタグではないが、バージョン固定を推奨 (DL3006の意図)
FROM python:3.10-slim-bullseye

# [Hadolint]
# 1. RUNが連続している (DL4006)
# 2. apt-get update が単独で実行されている (DL3007)
#
# ★Debian 11 のリポジトリは有効なため、これは成功します
RUN apt-get update

# [Hadolint]
# 1. --no-install-recommends がない (DL3008)
# 2. apt-get clean していない (DL3009)
# [Trivy]
# 1. curl や wget にも脆弱性が存在する可能性があります
RUN apt-get install -y curl wget

# [Hadolint]
# 1. --no-cache-dir がない (DL3013)
# [Trivy]
# 1. 既知の脆弱性(CVE)がある古いPythonライブラリをインストール
#    -> requests 2.19.1 には CVE-2018-18074 があります
RUN pip install requests==2.19.1
RUN pip install flask==1.0.2

# [Hadolint]
# 1. USERが指定されておらず、rootで実行される (DL3002)
# 2. HEALTHCHECK がない (DL4000)

# [Hadolint]
# 1. CMD は JSON 形式（exec form）であるべき (DL3025)
CMD /bin/bash -c "echo 'Vulnerable server starting...' && python -m http.server 8080"
