def worker(file):
    ddir = '../../Second Twitter Flooding Paper/Data/Daily Tweets Coastal Cities/'
    new_name = file
    fname =  ddir + file
    #print(fname)
    df = pd.read_csv(fname, engine='python')
    df = df[df['text'].notna()]
    full_texts = [t for t in df['text']]
    sequences = tokenizer.texts_to_sequences(full_texts)
    new_data = pad_sequences(sequences, maxlen=MAX_SEQUENCE_LENGTH)
    preds = loaded_model.predict(new_data)
    df['Probability_Flooding_V2'] = preds
    df.to_csv('../input/coastal_city_by_day/'+os.path.basename(fname))
