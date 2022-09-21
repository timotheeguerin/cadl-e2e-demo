import { Operation, Program } from "@cadl-lang/compiler";
import {
  getAllRoutes,
  OperationContainer,
  OperationDetails,
} from "@cadl-lang/rest/http";

export function getRestOperationDefinition(
  program: Program,
  operation: Operation
): OperationDetails {
  const [routes, _diagnostics] = getAllRoutes(program);
  console.log("Op",operation.name, routes.map(x=> x.operation.name))
  const [info] = routes.filter((r) => r.operation === operation);
  if (!info) {
    throw new Error("No route for operation.");
  }
  return info;
}

export function getRestOperationsWithin(
  program: Program,
  scope: OperationContainer
): OperationDetails[] {
  const [routes, _diagnostics] = getAllRoutes(program);
  return routes.filter((r) => r.container === scope);
}
