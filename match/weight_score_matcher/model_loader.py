import torch
import os
from transformers import AutoModelForCausalLM, AutoTokenizer
from accelerate import Accelerator
from config import LOCAL_MODEL_PATH, MODEL_PRECISION, DEVICE, NUM_GPUS


def load_local_model():
    print(f"从 {LOCAL_MODEL_PATH} 加载模型...")
    accelerator = Accelerator()
    device = accelerator.device
    dtype_map = {"fp16": torch.float16, "bf16": torch.bfloat16, "fp32": torch.float32}
    torch_dtype = dtype_map.get(MODEL_PRECISION, torch.float16)
    tokenizer = AutoTokenizer.from_pretrained(LOCAL_MODEL_PATH)
    tokenizer.padding_side = "left"
    if tokenizer.pad_token is None:
        tokenizer.pad_token = tokenizer.eos_token

    if tokenizer.unk_token is None:
        if "<unk>" in tokenizer.get_vocab():
            tokenizer.unk_token = "<unk>"
        elif "[UNK]" in tokenizer.get_vocab():
            tokenizer.unk_token = "[UNK]"
        else:
            print("警告: 分词器没有定义未知token，将不会过滤未知token")

    os.environ["CUDA_VISIBLE_DEVICES"] = "0,1,2"
    model = AutoModelForCausalLM.from_pretrained(
        LOCAL_MODEL_PATH,
        torch_dtype=torch_dtype,
        device_map="auto",
        trust_remote_code=True,
        load_in_4bit=False,
    )
    print(f"模型设备: {model.device}")
    model.eval()
    for param in model.parameters():
        param.requires_grad = False

    print(f"模型已加载到 {device}，使用 {NUM_GPUS} 块GPU")
    return model, tokenizer, accelerator
