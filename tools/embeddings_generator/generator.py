from sentence_transformers import SentenceTransformer

# Load the pretrained all-MiniLM-L6-v2 model
model = SentenceTransformer("all-MiniLM-L6-v2")

# Define the sentences you want to embed
sentences = [
    "This is an example sentence.",
    "Sentence embeddings are really useful.",
    "How well does this model capture meaning?",
]

# Generate embeddings for the sentences
embeddings = model.encode(sentences)

# Print the embeddings
for sentence, embedding in zip(sentences, embeddings):
    print(f"Sentence: {sentence}")
    print(f"Embedding (shape {embedding.shape}):\n{embedding}\n")
