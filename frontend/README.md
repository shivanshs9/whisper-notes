# Whisper Web

### Original excerpt
> ML-powered speech recognition directly in your browser! Built with [🤗 Transformers.js](https://github.com/xenova/transformers.js).
> Check out the demo site [here](https://huggingface.co/spaces/Xenova/whisper-webgpu).
> https://github.com/xenova/whisper-web/assets/26504141/5d6ed3d9-5f99-4d89-8e38-9d4fc8d5baaf

## Running locally

1. Update the [.env](.env) file with url to backend (make sure the URL is pointing to envoy proxy and not gRPC service directly).
1. Make sure to first generate the protoc files for frontend code (one time activity):

```bash
bash ../proto-gen.sh
```
3. Run the development server:

    ```bash
    yarn dev
    ```
    > Firefox users need to change the `dom.workers.modules.enabled` setting in `about:config` to `true` to enable Web Workers.
    > Check out [this issue](https://github.com/xenova/whisper-web/issues/8) for more details.

4. Open the link (e.g., [http://localhost:5173/](http://localhost:5173/)) in your browser.
