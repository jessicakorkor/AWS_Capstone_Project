# AWS Translation Service

A serverless translation service built with AWS CloudFormation, Lambda, S3, and AWS Translate. This project automatically translates text uploaded to S3 buckets using AWS's machine learning translation service.

## 🏗️ Architecture

The service uses a simple, event-driven serverless architecture:

- **Amazon S3**: Two buckets for input (requests) and output (responses)
- **AWS Lambda**: Python function triggered by S3 uploads to process translation requests
- **AWS Translate**: ML-powered translation service supporting 75+ languages
- **AWS Comprehend**: Automatic language detection
- **CloudFormation**: Infrastructure as Code for complete resource provisioning
- **IAM**: Secure role-based permissions

## ✨ Features

- ✅ **Event-driven processing**: Automatically processes files when uploaded to S3
- ✅ **Multi-language support**: Translate to/from 75+ languages
- ✅ **Auto language detection**: Uses AWS Comprehend when source language isn't specified
- ✅ **Lifecycle management**: Automatic file cleanup after 30 days
- ✅ **Serverless**: Pay only for what you use, scales automatically
- ✅ **Free Tier friendly**: Designed to work within AWS Free Tier limits
- ✅ **Infrastructure as Code**: Complete deployment with a single CloudFormation template

## 📁 Project Structure

```
AWS_CAPSTONE_PROJECT/
├── template.yaml           # CloudFormation template with inline Lambda code
├── test_request.json       # Sample translation request
├── create_stack.sh  # Deployment script
├── README.md              # This documentation
└── .gitignore            # Git ignore rules
```

## 🚀 Quick Start

### Prerequisites

- AWS CLI installed and configured
- AWS account with appropriate permissions for:
  - CloudFormation, Lambda, S3, IAM, Translate, Comprehend

### 1. Clone and Deploy

```bash
# Clone the repository
git clone <your-repo-url>
cd AWS_CAPSTONE_PROJECT

# Deploy the stack
./create_stack.sh
```

### 2. Test the Service

```bash
# Wait for stack creation to complete
aws cloudformation wait stack-create-complete --stack-name translation-service

# Get bucket names from stack outputs
REQUEST_BUCKET=$(aws cloudformation describe-stacks --stack-name translation-service --query 'Stacks[0].Outputs[?OutputKey==`RequestBucketName`].OutputValue' --output text)

# Upload test file
aws s3 cp test_request.json s3://$REQUEST_BUCKET/

# Check for translated result (wait a few seconds)
RESPONSE_BUCKET=$(aws cloudformation describe-stacks --stack-name translation-service --query 'Stacks[0].Outputs[?OutputKey==`ResponseBucketName`].OutputValue' --output text)
aws s3 ls s3://$RESPONSE_BUCKET/
```

### 3. View Results

```bash
# Download the translated result
aws s3 cp s3://$RESPONSE_BUCKET/test_request_translated.json ./result.json
cat result.json
```

## 📋 Request Format

Upload JSON files to the request bucket with this format:

```json
{
    "word": "Text to translate",
    "target_language": "fr"
}
```

**Supported language codes**: `en`, `fr`, `es`, `de`, `it`, `pt`, `ja`, `ko`, `zh`, `ar`, `hi`, and [many more](https://docs.aws.amazon.com/translate/latest/dg/what-is.html#what-is-languages)

## 📤 Response Format

The service outputs translated results with this format:

```json
{
    "original": "Text to translate",
    "translated": "Texte à traduire"
}
```

## 🛠️ Configuration

### Template Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `Region` | `us-east-1` | AWS region for deployment |
| `RequestBucketName` | `jessiek-requests-bucket` | Input S3 bucket name (must be globally unique) |
| `ResponseBucketName` | `jessiek-responses-bucket` | Output S3 bucket name (must be globally unique) |
| `LifecycleExpirationDays` | `30` | Days before files are automatically deleted |
| `DefaultTargetLang` | `fr` | Default target language if not specified |

### Environment Variables (Lambda)

| Variable | Description |
|----------|-------------|
| `RESPONSE_BUCKET` | Target bucket for translated files |
| `DEFAULT_TARGET_LANG` | Fallback target language |

## 🔧 Customization

### Adding New Languages

The service supports all languages available in AWS Translate. Simply change the `target_language` in your request JSON.

### Batch Processing

To translate multiple files:

```bash
# Upload multiple files
for file in *.json; do
    aws s3 cp "$file" s3://$REQUEST_BUCKET/
done
```

### Custom File Processing

Modify the inline Lambda code in `template.yaml` lines 103-156 to:
- Support different file formats
- Add preprocessing/postprocessing
- Integrate with other AWS services


## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make changes and test thoroughly
4. Submit a pull request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 📚 Additional Resources

- [AWS CloudFormation Documentation](https://docs.aws.amazon.com/cloudformation/)
- [AWS Translate Developer Guide](https://docs.aws.amazon.com/translate/)
- [AWS Lambda Python Guide](https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html)
- [Supported Language Pairs](https://docs.aws.amazon.com/translate/latest/dg/what-is.html#what-is-languages)