
    import { AzureFunction, Context, HttpRequest } from "@azure/functions";
    import { Host } from "../Host.js";
    import "../index.js";

    const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<void> {
       const comment = req.body;
       const _result = await Host.createComment(comment);
       context.res = {
      status: _result.statusCode,
      body: (_result as any).body
    } 
    };
    export default httpTrigger;