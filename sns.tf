data "template_file" "aws_cf_sns_stack" {
  #template = file("${path.module}/templates/cf_aws_sns_email_stack.json.tpl")
  template = <<EOF
{
 "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "SNSTopic": {
      "Type": "AWS::SNS::Topic",
      "Properties": {
        "TopicName": "${var.sns_topic_name}",
        "DisplayName": "${var.sns_topic_display_name}",
        "Subscription": [
           {
             "Endpoint": "${var.sns_subscription_email_address_list}",
             "Protocol": "${var.sns_subscription_protocol}"
           }
        ]
      }
    }
  }
}
EOF
}

resource "aws_cloudformation_stack" "tf_sns_topic" {
  name          = "snsStack"
  template_body = data.template_file.aws_cf_sns_stack.rendered
  tags = {
    name = "snsStack"
  }
}