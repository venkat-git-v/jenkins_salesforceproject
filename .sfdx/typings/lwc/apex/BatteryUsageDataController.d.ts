declare module "@salesforce/apex/BatteryUsageDataController.checkReportSubms" {
  export default function checkReportSubms(param: {rsID: any}): Promise<any>;
}
declare module "@salesforce/apex/BatteryUsageDataController.getUsageData" {
  export default function getUsageData(): Promise<any>;
}
declare module "@salesforce/apex/BatteryUsageDataController.createUsageData" {
  export default function createUsageData(param: {usageDataWrapperList: any, rsID: any, totalFee: any}): Promise<any>;
}
