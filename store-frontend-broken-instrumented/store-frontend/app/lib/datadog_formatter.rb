require 'json'
require 'ddtrace'

class DatadogFormatter < SemanticLogger::Formatters::Raw
  def initialize(time_format: :iso_8601, time_key: :timestamp, **args)
    super(time_format: time_format, time_key: time_key, **args)
  end

  # Flatten out the JSON keys
  def named_tags
    hash[:tags].merge(log.named_tags) if log.named_tags && !log.named_tags.empty?
  end

  def datadog_tracer
    correlation = Datadog.tracer.active_correlation
    # Adds IDs as tags to log output
    hash[:dd] = {
      trace_id: correlation.trace_id.to_s,
      span_id: correlation.span_id.to_s,
      env: correlation.env.to_s,
      service: correlation.service.to_s,
      version: correlation.version.to_s
    }
    hash[:ddsource] = ['ruby']
  end

  # Returns log messages in JSON format
  def call(log, logger)
    super(log, logger)
    datadog_tracer
    hash.to_json
  end
end
