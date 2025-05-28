import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const appName = 'AI Assistant';
late Size mq;

// API Keys
final apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? '';
final huggingFaceKey = dotenv.env['HUGGING_FACE_KEY'] ?? ''; // Add this line
final openArtKey = dotenv.env['IMAGINE_ART_KEY'] ?? '';
