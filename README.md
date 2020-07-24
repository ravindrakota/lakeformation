# lakeformation

http://d6ea773e-istiosystem-istio-2af2-1452460012.us-east-1.elb.amazonaws.com/notebook/rheiberger/test/tree?

vpce-04186865cfd9a24cb-f5de3g4l.server.transfer.us-east-1.vpce.amazonaws.com

FREDDIE_ICN01_SFCRole=2_RqFVXteZsAQ69tFExGtP8xGSsoI=

d1rbuj2z7ky5yd.cloudfront.net

AWSTemplateFormatVersion: '2010-09-09'
Resources:
  SnowFlakeRole:
    Properties:
      AssumeRolePolicyDocument:
        Statement:
          - Action:
              - 'sts:AssumeRole'
            Effect: Allow
            Principal: { "AWS": "arn:aws:iam::212740118925:user/phzi-s-vast4186" }
            Condition: {
              "StringEquals": {
                  "sts:ExternalId": "FREDDIE_ICN01_SFCRole=2_FlSflImozOd+W/lXcfUhs2vg/WU="
              }
            }
        Version: 2012-10-17
      ManagedPolicyArns:
        - 'arn:aws:iam::882091528373:policy/snowflake_access'
      Path: /
      PermissionsBoundary: !Join 
        - ''
        - - 'arn:aws:iam::'
          - !Ref 'AWS::AccountId'
          - ':policy/FreddieMacRoleAccessBoundary'
      RoleName: snowflake_access_role
    Type: 'AWS::IAM::Role'
    
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEWATrXQQEok55I0KxNh/+ZNmABjvLVnQaNYXBNTaqJ2WMvMW70A/2TC8s+/MJXT/V2M+BC89Gt2YwTkiHS6aocsbMUs8H4jebl73qkDh/lQoMZwsJ9eNaHbpwiZaSbR8IdzqqhieXEB4mlehc/HQ58Mi/Gjzju22BbOFH76NuZPG7CSmYVkDhRRl0PxHqZ5iF/oowjZhCVltA7ITC+Ch4UCAxQFcoH2uc7C9SXI/dkzy4Zrgjc6eSyeWGHmOAH7BRwfiS7tx3SzN5H/IonWQ975Tndwz+UDYeQ/pUFJRHEXgybfnmv0Tg8QzAnrxd0tavhv6/3p6dN45tTp5M+ZQnYmdnPK8rgMLFS5P1fTl7ZT29PX4xkOzjEGOPcr6W0lfmglBC7B8JD4QCcsb+SNlqpWCTkSTvKjS30ZnQNZxBvbpIJCf7ZBsGqOiwBGorv7LNLefaOF3qesS2yRMkNIAIwbm4err4Wi9MPGiYlHuisqNtWuiRiecUqkKBvFGXGvM= rkota@IP-AC1F6B3F
    
    https://cloud.mongodb.com/v2/5f19ea8ff5f1de4a0d04e849#clusters



