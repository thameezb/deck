'use strict';

var gateHost = 'https://spinnaker.double.tech/gate';
var atlasWebComponentsUrl = '';
var authEnabled = 'true' === 'true';
var authEndpoint = gateHost + '/auth/user';
var bakeryDetailUrl = gateHost + '/bakery/logs/{{context.region}}/{{context.status.resourceId}}';
var canaryFeatureDisabled = 'false' !== 'true';
var canaryStagesEnabled = '{%canary.stages%}' === 'true';
var chaosEnabled = 'false' === 'true';
var defaultCanaryJudge = '{%canary.defaultJudge%}';
var defaultMetricsStore = '{%canary.defaultMetricsStore%}';
var defaultMetricsAccountName = '{%canary.defaultMetricsAccount%}';
var defaultStorageAccountName = '{%canary.defaultStorageAccount%}';
var fiatEnabled = 'true' === 'true';
var mineCanaryEnabled = 'false' === 'true';
var pipelineTemplatesEnabled = 'true' === 'true';
var reduxLoggerEnabled = '{%canary.reduxLogger%}' === 'true';
var showAllConfigsEnabled = '{%canary.showAllCanaryConfigs%}' === 'true';
var slack = {
  botName: '',
  enabled: 'false' === 'true',
};
var sms = {
  enabled: 'false' === 'true',
};
var githubStatus = {
  enabled: 'false' === 'true',
};
var templatesEnabled = '{%canary.templatesEnabled%}' === 'true';
var timezone = 'Etc/UTC';
var version = '1.28.1';

// Cloud Providers
var appengine = {
  defaults: {
    account: '',
  },
};
var oracle = {
  defaults: {
    account: '{%oracle.default.account%}',
    bakeryRegions: '{%oracle.default.bakeryRegions%}',
    region: '{%oracle.default.region%}',
  },
};
var aws = {
  defaults: {
    account: '',
    region: '{%aws.default.region%}',
  },
};
var azure = {
  defaults: {
    account: '',
    region: 'westus',
  },
};
var cloudfoundry = {
  defaults: {
    account: '',
  },
};
var dcos = {
  defaults: {
    account: '',
  },
};
var ecs = {
  defaults: {
    account: '',
  },
};
var gce = {
  defaults: {
    account: '',
    region: 'us-central1',
    zone: 'us-central1-f',
  },
};
var huaweicloud = {
  defaults: {
    account: '',
    region: '{%huaweicloud.default.region%}',
  },
};
var tencentcloud = {
  defaults: {
    account: '',
    region: '{%tencentcloud.default.region%}',
  },
};

window.spinnakerSettings = {
  authEnabled: authEnabled,
  authEndpoint: authEndpoint,
  bakeryDetailUrl: bakeryDetailUrl,
  canary: {
    atlasWebComponentsUrl: atlasWebComponentsUrl,
    defaultJudge: defaultCanaryJudge,
    featureDisabled: canaryFeatureDisabled,
    reduxLogger: reduxLoggerEnabled,
    metricsAccountName: defaultMetricsAccountName,
    metricStore: defaultMetricsStore,
    showAllConfigs: showAllConfigsEnabled,
    stagesEnabled: canaryStagesEnabled,
    storageAccountName: defaultStorageAccountName,
    templatesEnabled: templatesEnabled,
  },
  defaultInstancePort: 80,
  defaultTimeZone: timezone, // see http://momentjs.com/timezone/docs/#/data-utilities/
  feature: {
    canary: mineCanaryEnabled,
    chaosMonkey: chaosEnabled,
    fiatEnabled: fiatEnabled,
    pipelineTemplates: pipelineTemplatesEnabled,
    roscoMode: true,
  },
  gateUrl: gateHost,
  notifications: {
    bearychat: {
      enabled: true,
    },
    email: {
      enabled: true,
    },
    githubStatus: githubStatus,
    googlechat: {
      enabled: true,
    },
    microsoftteams: {
      enabled: true,
    },
    pubsub: {
      enabled: true,
    },
    slack: slack,
    sms: sms,
  },
  providers: {
    appengine: appengine,
    aws: aws,
    azure: azure,
    cloudfoundry: cloudfoundry,
    dcos: dcos,
    ecs: ecs,
    gce: gce,
    huaweicloud: huaweicloud,
    kubernetes: {},
    oracle: oracle,
    tencentcloud: tencentcloud,
  },
  version: version,
};
