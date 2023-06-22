import {DOMWidgetModel} from "@jupyter-widgets/base";
import {MODULE_VERSION} from "./version";

export class MyWidgetModel extends DOMWidgetModel {
  static serializers = {
    ...DOMWidgetModel.serializers,
    // Add any extra serializers here
  };

  static modelName = "MyWidgetModel";

  static modelModule = "jupyter_template";

  static modelModuleVersion = MODULE_VERSION;

  static viewName = "MyWidgetView"; // Set to null if no view

  static viewModule = "jupyter_template"; // Set to null if no view

  static viewModuleVersion = MODULE_VERSION;

  defaults() {
    return {
      ...super.defaults(),
      _model_name: MyWidgetModel.modelName,
      _model_module: MyWidgetModel.modelModule,
      _model_module_version: MyWidgetModel.modelModuleVersion,
      _view_name: MyWidgetModel.viewName,
      _view_module: MyWidgetModel.viewModule,
      _view_module_version: MyWidgetModel.viewModuleVersion,
    };
  }
}
