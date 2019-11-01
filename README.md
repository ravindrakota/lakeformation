# lakeformation

http://d6ea773e-istiosystem-istio-2af2-1452460012.us-east-1.elb.amazonaws.com/notebook/rheiberger/test/tree?

vpce-04186865cfd9a24cb-f5de3g4l.server.transfer.us-east-1.vpce.amazonaws.com

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



