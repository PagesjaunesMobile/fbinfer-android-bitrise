# Infer Android Step for Bitrise

This step will use [FbInfer App](http://fbinfer.com) in order to check your code

# How to use it

Modify your `bitrise.yml` in order to test it.

```yaml
    - git::https://github.com/PagesjaunesMobile/fbinfer-android-bitrise@master:
        inputs:
          - infer_source_dir: $BITRISE_SOURCE_DIR
          - infer_gradle_task: $GRADLE_TASK
          - infer_debug_mode: Set it to true if you want to see what command are send to the system
```
