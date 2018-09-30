FROM centos

RUN yum -y update && yum -y install epel-release && yum -y install jq wget curl

RUN groupadd vault && \
    adduser -g vault vault && \
    mkdir /vault && \
    chown -R vault:vault /vault && \
    chmod -R 777 /vault


WORKDIR /vault

RUN wget https://github.com/openshift/origin/releases/download/v3.10.0/openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit.tar.gz

RUN tar zxvf openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit.tar.gz && \
    cp openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit/oc .

ADD getsecrets.sh /vault

ADD remote_test.sh /vault

USER vault

CMD ["./getsecrets.sh"]