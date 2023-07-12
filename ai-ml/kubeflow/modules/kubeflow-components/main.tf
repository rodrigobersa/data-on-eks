resource "kubernetes_namespace" "kubeflow" {
  metadata {
    labels = {
      control-plane   = "kubeflow"
      istio-injection = "enabled"
    }

    name = "kubeflow"
  }
}

module "kubeflow_issuer" {
  source = "../kubeflow-issuer"
  helm_config = {
    chart = "../../charts/kubeflow-issuer"
  }

  addon_context = var.addon_context
  depends_on    = [kubernetes_namespace.kubeflow]
}

module "kubeflow_istio" {
  source = "../istio"
  helm_config = {
    chart = "../../charts/istio"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_issuer]
}

module "kubeflow_dex" {
  source = "../dex"
  helm_config = {
    chart = "../../charts/dex"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_istio]
}

module "kubeflow_oidc_authservice" {
  source = "../oidc-authservice"
  helm_config = {
    chart = "../../charts/oidc-authservice"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_dex]
}

module "kubeflow_knative_serving" {
  source = "../knative-serving"
  helm_config = {
    chart = "../../charts/knative-serving"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_oidc_authservice]
}

module "kubeflow_cluster_local_gateway" {
  source = "../cluster-local-gateway"
  helm_config = {
    chart = "../../charts/cluster-local-gateway"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_knative_serving]
}

module "kubeflow_knative_eventing" {
  source = "../knative-eventing"
  helm_config = {
    chart = "../../charts/knative-eventing"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_cluster_local_gateway]
}

module "kubeflow_roles" {
  source = "../kubeflow-roles"
  helm_config = {
    chart = "../../charts/kubeflow-roles"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_knative_eventing]
}

module "kubeflow_istio_resources" {
  source = "../kubeflow-istio-resources"
  helm_config = {
    chart = "../../charts/kubeflow-istio-resources"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_roles]
}

module "kubeflow_pipelines" {
  source = "../apps/kubeflow-pipelines"
  helm_config = {
    chart = "../../charts/apps/kubeflow-pipelines/vanilla"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_istio_resources]
}

module "kubeflow_kserve" {
  source = "../kserve"
  helm_config = {
    chart = "../../charts/kserve"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_pipelines]
}

module "kubeflow_models_web_app" {
  source = "../apps/models-web-app"
  helm_config = {
    chart = "../../charts/apps/models-web-app"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_kserve]
}

module "kubeflow_katib" {
  source = "../apps/katib"
  helm_config = {
    chart = "../../charts/apps/katib/vanilla"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_models_web_app]
}

module "kubeflow_central_dashboard" {
  source = "../apps/central-dashboard"
  helm_config = {
    chart = "../../charts/apps/central-dashboard"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_katib]
}

module "kubeflow_admission_webhook" {
  source = "../apps/admission-webhook"
  helm_config = {
    chart = "../../charts/apps/admission-webhook"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_central_dashboard]
}

module "kubeflow_notebook_controller" {
  source = "../apps/notebook-controller"
  helm_config = {
    chart = "../../charts/apps/notebook-controller"
    set = [
      {
        name  = "cullingPolicy.cullIdleTime",
        value = var.notebook_cull_idle_time
      },
      {
        name  = "cullingPolicy.enableCulling",
        value = var.notebook_enable_culling
      },
      {
        name  = "cullingPolicy.idlenessCheckPeriod",
        value = var.notebook_idleness_check_period
      }
    ]
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_admission_webhook]
}

module "kubeflow_jupyter_web_app" {
  source = "../apps/jupyter-web-app"
  helm_config = {
    chart = "../../charts/apps/jupyter-web-app"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_notebook_controller]
}

module "kubeflow_profiles_and_kfam" {
  source = "../apps/profiles-and-kfam"
  helm_config = {
    chart = "../../charts/apps/profiles-and-kfam"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_jupyter_web_app]
}

module "kubeflow_volumes_web_app" {
  source = "../apps/volumes-web-app"
  helm_config = {
    chart = "../../charts/apps/volumes-web-app"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_profiles_and_kfam]
}

module "kubeflow_tensorboards_web_app" {
  source = "../apps/tensorboards-web-app"
  helm_config = {
    chart = "../../charts/apps/tensorboards-web-app"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_volumes_web_app]
}

module "kubeflow_tensorboard_controller" {
  source = "../apps/tensorboard-controller"
  helm_config = {
    chart = "../../charts/apps/tensorboard-controller"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_tensorboards_web_app]
}

module "kubeflow_training_operator" {
  source = "../apps/training-operator"
  helm_config = {
    chart = "../../charts/apps/training-operator"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_tensorboard_controller]
}

module "kubeflow_aws_telemetry" {
  count  = var.enable_aws_telemetry ? 1 : 0
  source = "../aws-telemetry"
  helm_config = {
    chart = "../../charts/aws-telemetry"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_training_operator]
}

module "kubeflow_user_namespace" {
  source = "../user-namespace"
  helm_config = {
    chart = "../../charts/user-namespace"
  }
  addon_context = var.addon_context
  depends_on    = [module.kubeflow_aws_telemetry]
}

module "ack_sagemaker" {
  source        = "../ack-sagemaker-controller"
  addon_context = var.addon_context
}
