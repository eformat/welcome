FROM registry.access.redhat.com/ubi7/ubi
#FROM registry.access.redhat.com/rhscl/perl-520-rhel7
RUN yum install --disableplugin=subscription-manager perl -y 
ADD ./hello.pl ./
CMD ["./hello.pl"]
