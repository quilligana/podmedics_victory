# required for amazon s3 eu location
Paperclip::Attachment.default_options[:s3_host_name] = 's3-eu-west-1.amazonaws.com'
Paperclip::Attachment.default_options[:s3_protocol] = :https
# Paperclip::Attachment.default_options[:url] = ":s3_domain_url"
# Paperclip::Attachment.default_options[:path] = '/:attachment/:style/:filename'
