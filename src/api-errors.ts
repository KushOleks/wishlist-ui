import { isAxiosError } from 'axios'

export function apiErrorMessage(error: unknown, fallback: string): string {
  if (isAxiosError<{ detail?: unknown }>(error)) {
    const detail = error.response?.data?.detail
    if (typeof detail === 'string') return detail
  }
  return fallback
}
