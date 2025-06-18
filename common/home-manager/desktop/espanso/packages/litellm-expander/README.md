# LiteLLM Expander for Espanso

This package integrates [LiteLLM](https://github.com/BerriAI/litellm) with Espanso, providing a seamless way to use various LLM providers like Ollama, OpenAI, OpenRouter, nano-gpt, Claude, and Perplexity directly from your text expander.

## Features

- Quick LLM queries with `;llm your prompt;`
- Form-based interface for longer prompts with `;llmw;`
- Role-based expansions:
  - Translation to Spanish: `;spanish your text;` or `;spanishw;` for form
  - Translation to French: `;french your text;` or `;frenchw;` for form
  - CLI command generation: `;cli describe command;` or `;cliw;` for form
  - Emoji conversion: `;emoji description;` or `;emojiw;` for form
- Configurable providers and models including:
  - Ollama (local models)
  - OpenAI (GPT models)
  - OpenRouter (multiple providers)
  - nano-gpt (TEE/llama-3.3-70b-instruct)
  - Claude (Anthropic models)
  - Perplexity (Sonar models)

## Setup

1. Ensure Python 3.6+ is installed
2. Install LiteLLM: `pip install litellm`
3. Configure your providers in `~/.config/espanso/litellm_config.yaml`

A default configuration file will be created automatically the first time you use the expander. You can modify it to include your API keys and preferred models.

### Configuration

The configuration file (`~/.config/espanso/litellm_config.yaml`) allows you to:

- Set default provider and model
- Configure API keys and endpoints for different providers
- Define role-specific prompts
- Adjust general parameters like temperature and max tokens

Example configuration:

```yaml
default_provider: "ollama"
default_model: "llama3:latest"

providers:
  ollama:
    api_base: "http://localhost:11434"
    models:
      default: "llama3:latest"
      fast: "llama3:8b"
      precise: "llama3:70b"
  
  openai:
    api_key: "your-api-key"
    models:
      default: "gpt-3.5-turbo"
      precise: "gpt-4"
      
  openrouter:
    api_key: "your-api-key"
    models:
      default: "anthropic/claude-3-sonnet"
      fast: "anthropic/claude-3-haiku"
      precise: "anthropic/claude-3-opus"
      
  nano-gpt:
    api_base: "https://nano-gpt.com"
    api_key: "your-api-key"
    models:
      default: "TEE/llama-3.3-70b-instruct"
  
  claude:
    api_base: "https://api.anthropic.com/v1"
    api_key: "your-api-key"
    models:
      default: "claude-3-sonnet-20240229"
      fast: "claude-3-haiku-20240307"
      precise: "claude-3-opus-20240229"
      
  perplexity:
    api_base: "https://api.perplexity.ai"
    api_key: "your-api-key"
    models:
      default: "sonar-medium-online"
      fast: "sonar-small-online"
      precise: "sonar-large-online"

roles:
  default: "You are a helpful assistant."
  spanish: "You are a translator. Translate to Spanish."
  french: "You are a translator. Translate to French."
  cli: "Generate a bash command based on this description."
  emoji: "Convert this text description into emojis only."

temperature: 0.7
max_tokens: 1000
```

## Examples

- Get a quick response: `;llm explain quantum computing;`
- Translate to Spanish: `;spanish Hello, how are you?;`
- Generate a CLI command: `;cli command to extract test.tar.gz;`
- Convert text to emojis: `;emoji guy in cowboy hat smiling;`

## Extending

You can add new roles or providers by editing the configuration file. The Python script handles the integration with LiteLLM, allowing you to use any provider supported by LiteLLM.