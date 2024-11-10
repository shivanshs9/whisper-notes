import { GrpcWebFetchTransport } from "@protobuf-ts/grpcweb-transport";

export const GrpcTransport = new GrpcWebFetchTransport({
    baseUrl: import.meta.env.VITE_GRPC_BACKEND!!
})
